class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_user, only: [:edit, :update]
  
  def index
    @book = Book.new
    @groups = Group.all
    @user = User.find(current_user.id)
  end
  
  def show
    @book = Book.new
    @user = User.find(current_user.id)
    @group = Group.find(params[:id])
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      group_user = current_user.group_users.new
      group_user.group_id = @group.id
      group_user.save
      redirect_to groups_path, method: :post
    else
      render 'new'
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render 'edit'
    end
  end
  
  def new_mail
    @group = Group.find(params[:group_id])
    @errors = ""
    @mail_title = ""
    @mail_content = ""
  end
  
  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    if @mail_title.blank?
      @errors = []
      @errors.push("Title can't be blank")
      if @mail_content.blank?
        @errors.push("Content can't be blank")
      end
    render :new_mail
    elsif @mail_content.blank?
      @errors = []
      @errors.push("Content can't be blank")
      render :new_mail
    else
      ContactMailer.send_mail(@group, @mail_title, @mail_content, group_users).deliver
    end
  end
  
  private
  
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
  
  def ensure_current_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
