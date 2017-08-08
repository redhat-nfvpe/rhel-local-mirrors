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

Also the following vars are set by default:
* subscribe_rhn: by default set to true, change if you want to skip the subscription step
* rhn_repos: list, by default set to the OSP10 repos. Please update it if you want to allow more repos

If you need to limit the playbook to subscribe to your system, please run the playbook with:
* --tags rhel_register

## System preparation

In order to create mirrors, several packages need to be installed on the system, and
firewall or iptables rules need to be created to enable FTP access. In order to do it, several
tasks tagged with `prepare_system` are executed.

## Mirror creation

This playbook can create mirrors based on the subscribed repos. It is based on the previously
specified `rhn_repos` setting, to create a local copy of these repos on the system.

The following vars are set by default:
* repo_folder: The target folder where the repo will be created. By default it is `osp_repo`,
creating the final repo in the /var/ftp/pub/osp_repo path
* repo_name: The name of the repo that will be created. By default it is `osp.repo`

To limit the playbook to just create the mirrors, please executed with:
--tags create_miror

## Repo synchronization

Regular syncs of the repo are required in order to keep it up to date. You can trigger just
the repo sync manually, executing the playbook with:
--tags sync_mirror

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

