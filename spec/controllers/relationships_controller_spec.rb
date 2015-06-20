require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it_behaves_like "require user" do
      let(:action) {get :index}
    end

    it "assigns @relationships variable" do
      alice = Fabricate(:user)
      set_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require user" do
      let(:action) {delete :destroy, id: 1}
    end

    let(:alice) {Fabricate(:user)}
    let(:bob) {Fabricate(:user)}
    let(:charlie) {Fabricate(:user)}

    before do
      set_user(alice)
    end
    
    it "redirects to people page" do
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to(people_path)
    end

    it "deletes the relationship" do
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      delete :destroy, id: relationship.id
      expect(alice.following_relationships.count).to eq(0)
    end

    it "deletes the relationship only if the current user is the follower" do
      relationship = Fabricate(:relationship, leader: bob, follower: charlie)
      delete :destroy, id: relationship.id
      expect(Relationship.all.count).to eq(1)
    end
  end

  describe "POST create" do
    it_behaves_like "require user" do
      let(:action) {post :create, leader_id: 1}
    end

    let(:alice) {Fabricate(:user)}
    let(:bob) {Fabricate(:user)}

    before { set_user(alice)}
    
    it "redirects to people path" do
      post :create, leader_id: bob.id
      expect(response).to redirect_to(people_path)
    end

    it "creates a new relationship" do
      post :create, leader_id: bob.id
      expect(alice.following_relationships.first.leader).to eq(bob)
    end

    it "does not create a relationship if it already exists" do
      Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader_id: bob.id
      expect(alice.following_relationships.count).to eq(1)
    end

    it "does not create a relationship with herself" do
      post :create, leader_id: alice.id
      expect(alice.following_relationships.count).to eq(0)
    end
  end
end