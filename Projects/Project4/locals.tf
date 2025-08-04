locals {
    user_data = yamldecode(file("./users.yaml")).users
    user_role_pair = flatten([for user in local.user_data: [for role in user.roles: {
        username = user.username
        role = role
    }]])
}