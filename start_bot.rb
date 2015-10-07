require 'telegram/bot'
require 'vk-ruby'
require 'json'
vkapp = VK::Application.new(app_id: 5092774, access_token: "651f5f11815dfc522785e10206cd4a1be22b91bda62b4a7f4fe6568fb67db5c21cb05830f2415e89db410", timeout: 100)
telegram_token = '128896230:AAEwC7sc0SZvOS_dWand86-4ixPGG43U6Vc'
Telegram::Bot::Client.run(telegram_token) do |bot|
  bot.listen do |message|
  	t_cmd = message.text.split[0]
  	case t_cmd
  	when "/inst"
  		t_gr = message.text.split("/inst ")[1]
  		if t_gr == nil then
  			bot.api.sendMessage(chat_id: message.chat.id, text: "/inst id_группы")
  		else
  			begin
  			bot.api.sendMessage(chat_id: message.chat.id, text: "-----Начинаю-сбор-#{t_gr}-----")
  			group_mem_count = vkapp.groups.getById(group_id: t_gr, fields: "members_count")[0]["members_count"]
  			bot.api.sendMessage(chat_id: message.chat.id, text: "Число участников: #{group_mem_count}")
			file = File.open("inst/#{t_gr}_inst.txt", "w+")
			n_accs = 0
			already_has = 0
  			while already_has < group_mem_count
 				members = vkapp.execute.getGroupMembers(group_id: t_gr, m_count: group_mem_count, already_has: already_has)
  				already_has = already_has + members.length
  				bot.api.sendMessage(chat_id: message.chat.id, text: "Обработано: #{already_has} из #{group_mem_count}")
  				members.each { |member| if member["instagram"] then file.puts("#{member["instagram"]}") end }
  				members.each { |member| if member["instagram"] then n_accs = n_accs+1 end }
  				sleep 0.333
  			end
  			bot.api.sendMessage(chat_id:message.chat.id, text: "Аккаунтов: #{n_accs}")
  			bot.api.sendMessage(chat_id:message.chat.id, text: "-----Закончил-сбор-----")
  			file.close
  			bot.api.sendDocument(chat_id:message.chat.id, document: File.new("inst/#{t_gr}_inst.txt"))
  			rescue
  				bot.api.sendMessage(chat_id: message.chat.id, text: "-----Ошибка-Попробуй-снова-----")
  			end
  		end
    when "/skype"
      t_gr = message.text.split("/skype ")[1]
      if t_gr == nil then
        bot.api.sendMessage(chat_id: message.chat.id, text: "/skype id_группы")
      else
        begin
        bot.api.sendMessage(chat_id: message.chat.id, text: "-----Начинаю-сбор-#{t_gr}-----")
        group_mem_count = vkapp.groups.getById(group_id: t_gr, fields: "members_count")[0]["members_count"]
        bot.api.sendMessage(chat_id: message.chat.id, text: "Число участников: #{group_mem_count}")
        file = File.open("inst/#{t_gr}_skype.txt", "w+")
        n_accs = 0
        already_has = 0
        while already_has < group_mem_count
        members = vkapp.execute.getGroupMembers(group_id: t_gr, m_count: group_mem_count, already_has: already_has)
          already_has = already_has + members.length
          bot.api.sendMessage(chat_id: message.chat.id, text: "Обработано: #{already_has} из #{group_mem_count}")
          members.each { |member| if member["skype"] then file.puts("#{member["skype"]}") end }
          members.each { |member| if member["skype"] then n_accs = n_accs+1 end }
          sleep 0.333
        end
        bot.api.sendMessage(chat_id:message.chat.id, text: "Аккаунтов: #{n_accs}")
        bot.api.sendMessage(chat_id:message.chat.id, text: "-----Закончил-сбор-----")
        file.close
        bot.api.sendDocument(chat_id:message.chat.id, document: File.new("inst/#{t_gr}_skype.txt"))
        rescue
          bot.api.sendMessage(chat_id: message.chat.id, text: "-----Ошибка-Попробуй-снова-----")
        end
      end
  	when "/vk"
  		t_vkid = message.text.split("/vk ")[1]
  		if t_vkid == nil then
  			bot.api.sendMessage(chat_id: message.chat.id, text: "/vk id_человека")
  		else
  			begin
  			bot.api.sendMessage(chat_id: message.chat.id, text: "-----Начинаю-сбор-#{t_gr}-----")
  			user = vkapp.users.get(user_ids: t_vkid, fields: 'bdate,city')
  			puts user
  			user[0].each { |key, value|
  			case key
  			when "first_name"
  				bot.api.sendMessage(chat_id: message.chat.id, text: "Имя: #{value}")
  			when "last_name"
  				bot.api.sendMessage(chat_id: message.chat.id, text: "Фамилия: #{value}")
  			when "bdate"
  				bot.api.sendMessage(chat_id: message.chat.id, text: "Дата рождения: #{value}")
  			when "city"
  				bot.api.sendMessage(chat_id: message.chat.id, text: "Город: #{value["title"]}")
  			else
  			end}
  			bot.api.sendMessage(chat_id:message.chat.id, text: "-----Закончил-сбор-----")
  			rescue
  				bot.api.sendMessage(chat_id: message.chat.id, text: "-----Ошибка-----")
  			end
  		end
  	else
  		bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.text}")
  	end
  end
end
