local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Spoonira"
obj.version = "1.0"
obj.author = "Pavel Makhov"
obj.homepage = "https://github.com/fork-my-spoons/github-activity.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.indicator = nil
obj.timer = nil
obj.usernames = {}
obj.username = nil
obj.passowrd = nil

obj.iconPath = hs.spoons.resourcePath("icons")

--- Converts string representation of date (2020-06-02T11:25:27Z) to date
local function parse_date(date_str)
    local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)%Z"
    local y, m, d, h, min, sec, _ = date_str:match(pattern)

    return os.time{year = y, month = m, day = d, hour = h, min = min, sec = sec}
end

--- Converts seconds to "time ago" representation, like '1 hour ago'
local function to_time_ago(seconds)
    local days = seconds / 86400
    if days > 1 then
        days = math.floor(days + 0.5)
        return days .. (days == 1 and ' day' or ' days') .. ' ago'
    end

    local hours = (seconds % 86400) / 3600
    if hours > 1 then
        hours = math.floor(hours + 0.5)
        return hours .. (hours == 1 and ' hour' or ' hours') .. ' ago'
    end

    local minutes = ((seconds % 86400) % 3600) / 60
    if minutes > 1 then
        minutes = math.floor(minutes + 0.5)
        return minutes .. (minutes == 1 and ' minute' or ' minutes') .. ' ago'
    end
end

local function generate_action_string(event)
    local action_string = event.type
    local icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
    local link = 'http://github.com/' .. event.repo.name

    if (event.type == "PullRequestEvent") then
        action_string = event.payload.action .. ' a pull request in'
        link = event.pr_url
        icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
    elseif (event.type == "IssuesEvent") then
        action_string = event.payload.action .. ' an issue in'
        link = event.payload.issue.html_url
        icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
    elseif (event.type == "IssueCommentEvent") then
        action_string = event.payload.action == 'created' and 'commented in issue' or event.payload.action .. ' a comment in'
        link = event.payload.issue.html_url
        icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
    elseif (event.type == "WatchEvent") then
        action_string = 'starred'
        icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
    elseif (event.type == "ForkEvent") then
        action_string = 'forked'
        icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
    elseif (event.type == "CreateEvent") then
        action_string = 'created'
    elseif (event.type == "PushEvent") then
        action_string = 'pushed to'
    elseif (event.type == "ReleaseEvent") then
        action_string = 'released ' .. event.payload.release.name .. ' at '
        icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
    end

    return { action_string = action_string, link = link, icon = icon }
end

local function updateMenu()
    local events_url = 'https://api.github.com/users/' .. obj.username .. '/received_events?per_page=10'
    local current_time = os.time(os.date("!*t"))
    hs.http.asyncGet(events_url, {accept = 'application/vnd.github.v3+json'}, function(status, body) 
        local events = hs.json.decode(body)
        local menu = {}
        for _, event in ipairs(events) do
            local action_string = generate_action_string(event)
            table.insert(menu, {
                image = hs.image.imageFromURL(event.actor.avatar_url):setSize({w=32,h=32}),
                title = hs.styledtext.new(event.actor.display_login .. ' ' .. action_string.action_string .. '\n' .. event.repo.name .. '\n')
                .. action_string.icon .. hs.styledtext.new(to_time_ago(os.difftime(current_time, parse_date(event.created_at))), {color = {hex = '#8e8e8e'}}),
                fn = function() os.execute('open ' .. action_string.link) end
            })
        end
        
        table.insert(menu, { title = '-'})

        local accounts_menu = {}

        if (#obj.usernames > 1) then
            for _, account in ipairs(obj.usernames) do
                table.insert(accounts_menu, {
                    title = account, 
                    checked = account == obj.username,
                    fn = function() 
                        obj.username = account 
                        updateMenu() 
                    end})
            end

            table.insert(menu, { title = 'Accounts', menu = accounts_menu})
        end
        table.insert(menu, { title = 'Refresh', fn = function() updateMenu() end})

        obj.indicator:setMenu(menu)
    end)
end


function obj:init()
    self.indicator = hs.menubar.new()
    self.indicator:setIcon(hs.image.imageFromPath(obj.iconPath .. '/GitHub-Mark-32px.png'):setSize({w=16,h=16}))

    self.timer = hs.timer.new(300, updateMenu)
end

function obj:setup(args)
    self.usernames = args.usernames
    self.username = args.usernames[1]
end

function obj:start()
    self.timer:fire()
    self.timer:start()
end


return obj