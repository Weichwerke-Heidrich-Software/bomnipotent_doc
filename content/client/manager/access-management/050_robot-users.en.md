+++
title = "Robot Users"
slug = "robot-users"
weight = 50
description = "Learn how to create and manage robot user accounts in BOMnipotent for secure automation, CI/CD integration, and role-based permissions."
+++

Not all accounts are necessarily associated with human users. BOMnipotent is built with pipeline integration in mind. To create an account to be used in automation, add the 'robot' option to the request:

{{< example "user_request_robot" >}}

This request will mark the account as a robot, and **not** send a verification mail. To approve such an account, you have to provide the 'robot' option.

{{< example user_approve_robot >}}

> [!NOTE]
> Since robot users are not verified, and typically have elevated permissions, you should be absolutely certain that this is the account you want to approve.

In ordner not to have to fish the generated keys from the somewhat hidden user folder, you can specify a desired path to store them:

{{< example "user_request_store_custom" "1.1.0" >}}

Now the robot requires permissions to upload BOMs, update vulnerabilities and to read but not modify CSAF documents Beginning with version 1.4.0, a convenience role "robot" grants these permissions:

{{< example "add_robot_role" "1.4.0" >}}

Note that this role grants read access to the CSAF documents of *all* products:

{{< example "robot_role_permissions" "1.4.0" >}}

You can of course change these permissions as you please.

Now you can use your robot's credentials in your [CI/CD](/integration/ci-cd/) pipeline.
