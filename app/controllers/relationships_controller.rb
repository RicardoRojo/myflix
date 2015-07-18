class RelationshipsController < AuthenticatedController

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end

  def create
    leader = User.find(params[:leader_id])
    current_user.follow(leader) unless  current_user.not_followable?(leader)
    redirect_to people_path
  end
end