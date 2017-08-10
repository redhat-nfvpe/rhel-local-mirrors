# rhel-local-mirrors

This is a set of playbooks to automate the local mirror creation
for RHEL repos in a system. It will perform two steps:
1. Subscribe the system into the RedHat network
2. Create local mirors for the repos specified

## How to use

The playbooks expect a group of servers called ``rhel_mirrors`` to be
created. Please create the group and add the servers for the ansible inventory
you would like to use.
It also expects a file  ~/.ansible/vars/rhel_local_mirrors_vars.yml to be
created, and populated with the settings you need to override.

After that, just run ``ansible-playbook site.yml -i /path/to/inventory``

## RHN subscription                                                             

On a Red Hat system, subscription of can be managed automatically        
if you pass the right credentials:                                              
* rhn_subscription_username                                                     
* rhn_subscription_password                                                     
* rhn_subscription_pool_id

Subscription to the RHN system is enabled by default. If you want to disable it, you
can set to False the `subscribe_rhn` var.

If you need to limit the playbook to subscribe to your system, please run the playbook with
--tags rhel_register

## System preparation

In order to create mirrors, several packages need to be installed on the system, and
firewall or iptables rules need to be created to enable FTP access. In order to do it, several
tasks tagged with `prepare_system` are executed.

## Mirror creation

This playbook can create mirrors based on the subscribed repos. It relies on a list of
mirrors being defined, using the `mirrors` var:

  ```mirrors:
    - name: osp8.repo
      folder: osp8_repo
      items:
        - repo_1
        - repo_2```

It expects a list of repositories to be defined. Each of the repo items contains the
following keywords:
* name: Name of the repository to be created
* folder: The final folder that will be used for the creation. It will create the repository under `/var/ftp/pub/<<folder>>` path
* items: List of RedHat repositories to be enabled.

This format is useful when you need to define several mirrors on your system, for different versions.
For example, you coud create a mirror for OSP8 and another for OSP10, just adding the needed items to the
list of mirrors, specifying all the repositories needed for each version.

To limit the playbook to just create the mirrors, please executed with
--tags create_miror

## Repo synchronization

Regular syncs of the repo are required in order to keep it up to date. You can trigger just
the repo sync manually, executing the playbook with --tags sync_mirror

Also you can setup a cronjob that will automatically trigger the repository
synchronization on the schedule you decide. To enable it, you need to set the
``repo_autosync`` var to True. To define the schedule for the cronjob, the following
vars can be set:
* crontab_day
* crontab_hour
* crontab_minute
* crontab_month
* crontab_weekday

When setting ``repo_autosync`` var to False, the cronjob will be removed. In order
to just setup the cronjob, you can execute the playbook with the ``prepare_cron`` tag.

