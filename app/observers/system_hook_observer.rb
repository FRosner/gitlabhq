class SystemHookObserver < ActiveRecord::Observer
  observe :user, :project, :users_project

  def after_create(model)
    case model
    when Project
      SystemHook.all_hooks_fire({
        event_name: "project_create",
        name: model.name,
        path: model.path,
        project_id: model.id,
        owner_name: model.owner.name,
        owner_email: model.owner.email,
        created_at: model.created_at
      })
    when User
      SystemHook.all_hooks_fire({
        event_name: "user_create",
        name: model.name,
        email: model.email,
        created_at: model.created_at
      })
    when UsersProject
      SystemHook.all_hooks_fire({
        event_name: "user_add_to_team",
        project_name: model.project.name,
        project_path: model.project.path,
        project_id: model.project_id,
        user_name: model.user.name,
        user_email: model.user.email,
        project_access: model.repo_access_human,
        created_at: model.created_at
      })
    end
  end

  def after_destroy(model)
    case model
    when Project
      SystemHook.all_hooks_fire({
        event_name: "project_destroy",
        name: model.name,
        path: model.path,
        project_id: model.id,
        owner_name: model.owner.name,
        owner_email: model.owner.email,
      })
    when User
      SystemHook.all_hooks_fire({
        event_name: "user_destroy",
        name: model.name,
        email: model.email
      })
    when UsersProject
      SystemHook.all_hooks_fire({
        event_name: "user_remove_from_team",
        project_name: model.project.name,
        project_path: model.project.path,
        project_id: model.project_id,
        user_name: model.user.name,
        user_email: model.user.email,
        project_access: model.repo_access_human
      })
    end
  end
end
