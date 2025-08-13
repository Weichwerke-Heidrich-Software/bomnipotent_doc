+++
title = "Robot Users"
slug = "robot-users"
weight = 50
+++

Not all accounts are necessarily associated with human users. BOMnipotent is built with pipeline integration in mind. To create an account to be used in automation, add the 'robot' option to the request:

{{< example "user_request_robot" >}}

This request will mark the account as a robot, and not send a verification mail.

If the account belongs to a robot, it can not be verified. In that case you can approve it with the 'robot' option.

{{< example user_approve_robot >}}

> [!NOTE]
> Since robot users are not verified, and typically have elevated permissions, you should be absolutely certain that this is the account you want to approve.

A plausible setup is to give the robot user roles with the permissions {{<bom-management-en>}} and {{<vuln-management-en>}}, enabling them to upload BOMs and update vulnerabilities:

{{< example user_role_add_robot >}}
