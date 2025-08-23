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

A plausible setup is to give the robot user roles with the permissions {{<bom-management-en>}} and {{<vuln-management-en>}}, enabling them to upload BOMs and update vulnerabilities:

{{< example user_role_add_robot >}}

Now you can use your robot's credentials in your [CI/CD](/integration/ci-cd/) pipeline.
