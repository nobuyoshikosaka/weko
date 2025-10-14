#!/bin/bash

# gitの更新
if [ $# != 0 ]; then
  git pull
  if [ $? != 0 ]; then
    exit $?
  fi
fi

# コンテンツの再配置
docker-compose exec web invenio collect -v
if [ $? != 0 ]; then
  exit $?
fi

# JavaScriptのビルド
docker-compose exec web invenio assets build
if [ $? != 0 ]; then
  exit $?
fi

# invenio.cfgの反映
docker-compose exec web bash -c "jinja2 /code/scripts/instance.cfg > /home/invenio/.virtualenvs/invenio/var/instance/invenio.cfg"
if [ $? != 0 ]; then
  exit $?
fi

# サービスの再起動
docker-compose restart web