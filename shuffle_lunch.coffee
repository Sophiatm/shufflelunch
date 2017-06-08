request = require('request')

module.exports = (robot) ->
  robot.hear /ランチメンバー教えて(.*)?/, (msg) ->
    groups = []
    numberOfGroup = 4
    request.get
      url: "https://slack.com/api/users.list?token=#{process.env.HUBOT_SLACK_TOKEN}"
      , (err, response, body) ->
        # Slack APIからメンバーを取得
        members = (member.name for member in JSON.parse(body).members)

        # シャッフル
        i = members.length
        while --i > 0
          j = ~~(Math.random() * (i + 1))
          member = members[j]
          members[j] = members[i]
          members[i] = member
        
        # グループ分け
        while members.length > 0
          group = members.splice(0, numberOfGroup)
          if group.length is numberOfGroup
            groups.push group
          else
            for member, index in group
              groups[index].push member
        
        # 応答
        msg.send "今日のランチグループはこちら"
        for group, index in groups
          msg.send "#{index+1}班: #{group.join(',')}"
