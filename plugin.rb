# name: badge-message
# about: get a PM explaining what badge you got
# version: 0.1
# authors: Christine Sunu


after_initialize do

	DiscourseEvent.on(:user_badge_granted) do

		badge = Badge.find_by("id"=>UserBadge.last.badge_id)
		user = User.find_by("id"=>UserBadge.last.user_id)

		msg = "You just got the #{badge.name} Badge!\n"

		if badge.long_description do
			msg += "\n#{badge.name}: #{badge.long_description}\n"
			end
		end

		msg += "\nEnjoy!!\n"

		r=PostCreator.new(User.find_by(id:-1), {
			title: "You Just Got The #{badge.name} Badge!",
			archetype: "private_message",
			is_warning: false,
			category: Category.first.name_lower,
			target_usernames: user.username,
			target_group_names: "",
			meta_data: {},
			raw: msg
		})
		post=r.create

		user.notifications.create(notification_type: Notification.types[:private_message],
                              topic_id: post.topic_id,
                              post_number: post.post_number,
                              data: { topic_title: post.topic.title,
                                      display_username: post.user.username }.to_json)
		
	end
	
end