#!/bin/bash
# LinuxGSM alert_slack.sh module
# Author: Daniel Gibbs
# Contributors: http://linuxgsm.com/contrib
# Website: https://linuxgsm.com
# Description: Sends Slack alert.

moduleselfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

json=$(
	cat << EOF
{
		"attachments": [
			{
				"color": "#36a64f",
				"blocks": [
					{
										"type": "section",
										"text": {
												"type": "mrkdwn",
												"text": "*LinuxGSM Alert*"
										}
								},
								{
										"type": "section",
										"text": {
												"type": "mrkdwn",
												"text": "*${alertemoji} ${alertsubject}* \n ${alertbody}"
										}
								},
								{
										"type": "divider"
								},
								{
										"type": "section",
										"fields": [
												{
														"type": "mrkdwn",
														"text": "*Game:* \n ${gamename}"
												},
												{
														"type": "mrkdwn",
														"text": "*Server IP:* \n ${alertip}:${port}"
												},
												{
														"type": "mrkdwn",
														"text": "*Server Name:* \n ${servername}"
												}
										]
								},
					 {
										"type": "section",
										"text": {
														"type": "mrkdwn",
														"text": "Hostname: ${HOSTNAME} / More info: ${alerturl}"
										}
								}
						]
			}
		]
}
EOF
)

fn_print_dots "Sending Slack alert"

slacksend=$(curl --connect-timeout 10 -sSL -H "Content-Type: application/json" -X POST -d "$(echo -n "${json}" | jq -c .)" "${slackwebhook}")

if [ "${slacksend}" == "ok" ]; then
	fn_print_ok_nl "Sending Slack alert"
	fn_script_log_pass "Sending Slack alert"
else
	fn_print_fail_nl "Sending Slack alert: ${slacksend}"
	fn_script_log_fatal "Sending Slack alert: ${slacksend}"
fi
