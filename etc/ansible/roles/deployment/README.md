Deploy Modern Go Application
============================

This role is used to deploy Modern Go Application from a CI/CD pipeline.

Requirements
------------

`modern-go-bootstrap` role should be applied to the host (either in a separate or in the same playbook).

Role Variables
--------------

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `binary_source` | *none* | Local source of the binaries to copy |
| `binary_name` | `modern-go-bootstrap` | Binary to copy |
| `sample_service_name` | `sample` | Service to be restarted |

Dependencies
------------

- `modern-go-bootstrap` role

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: deploy-modern-go-bootstrap, binary_source: build/ }

License
-------

MIT
