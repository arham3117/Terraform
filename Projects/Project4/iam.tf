# Creating users

resource "aws_iam_user" "users" {
    for_each = toset(local.user_data[*].username)
    name = each.value
}

# Password Creation
resource "aws_iam_user_login_profile" "profile" {
    for_each = aws_iam_user.users
    user = each.value.name
    password_length = 12

    lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

# Attaching Policies
resource "aws_iam_user_policy_attachment" "attach" {
    for_each = {
        for pair in local.user_role_pair:
        "${pair.username}-${pair.role}" => pair
    }

  user       = aws_iam_user.users[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}