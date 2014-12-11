{% for pkg in salt['pillar.get']('php:packages') %}
Install {{pkg}}:
  pkg.installed:
    - name: {{pkg}}
{% endfor %}

{% if salt['pillar.get']('php:use_xdebug') %}
Install xdebug:
  pkg.installed:
    - name: {{salt['pillar.get']('php:pkg_names:xdebug')}}
{% else %}
Uninstall xdebug:
  pkg.removed:
    - name: {{salt['pillar.get']('php:pkg_names:xdebug')}}
{% endif %}

Download composer:
  cmd.run:
    - cwd: /tmp
    - name: '`which curl` -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer

Install composer:
  cmd.wait:
    - name: mv /tmp/composer.phar /usr/local/bin/composer
    - cwd: /root
    - unless: test -f /usr/local/bin/composer
    - watch:
      - cmd: Download composer
