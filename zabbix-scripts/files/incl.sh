#!{{bash}}
{% if data %}
{% for name,value in data.iteritems() %}
{{name|upper}}="{{value}}"
{% endfor %}
{% endif %}
