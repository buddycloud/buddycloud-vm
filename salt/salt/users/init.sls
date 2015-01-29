{% for name, user in pillar.get('users', {}).items() %}
{{name}}:
  user.{{user.state}}:
  {% if user.state == 'present' %}
    - fullname: {{user.fullname}}
    - shell: {{user.shell}}
    - home: {{user.home}}
    - uid: {{user.uid}}
    - groups: {{user.groups}}
ssh_key_{{name}}:
  ssh_auth:
    - present
    - user: {{name}}
    - names: 
      - {{user.pubkey}}
    - require:
      - user: {{ name }}
  {% elif user.state == 'absent' %}
    - purge: {{user.purge}}
  {% endif %}
{% endfor %}
