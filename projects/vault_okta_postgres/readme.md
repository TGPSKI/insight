# Vault Okta Postgres

Two stage project demonstrating an end to end postgres, vault, vault -> okta, and vault -> postgres implementation.

Apply stage 1 first, followed by stage 2.

The two stage approach is required due to a lack of provider `depends_on` functionality. See:

* https://github.com/hashicorp/terraform/issues/2430
* https://github.com/hashicorp/terraform/issues/13018
* https://github.com/hashicorp/terraform/issues/17847
