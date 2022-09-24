# NotionSDK.jl
NotionSDK is a simple and easy to use client library for the official [Notion API](https://developers.notion.com/).(Havily inspired by [notion-sdk-py](https://github.com/ramnes/notion-sdk-py))

What is worked: 
1. each api in notion website is worked, except some was deprecated.
2. the `body` or `query` should be inputted as `Dictionary` or a `Config` from `EasyConfig.jl`.
3. The return is `JSON3.Object` or `JSON3.Array` depends on the function calls.

Should Improved (TO DO):
1. The `Base.show` for client should be dispatched.
2. simplify the Exception message. 
3. add some explanation in the code.

## Basic Examples
### SetUps
```Julia
using DotEnv
using EasyConfig
DotEnv.config("test/.env");

NOTION_TOKEN = ENV["NOTION_TOKEN"];
database_id = ENV["database_id"];
page_id = ENV["database_id"];
user_id = ENV["database_id"];
notion = Client(NOTION_TOKEN)
```

### The API
```Julia
list_users(notion)
get_me(notion)
# check notion website for the usage
retrieve_user(notion, user_id)

retrive_block(notion, block_id)

retrieve_page(notion, page_id)

list_block_children(notion, page_id)

#query database
filter = Config()
filter.property = "Name"
filter.title.equals = some_name
print(filter)
sort_1 = Config()
sort_1.property = "Name"
sort_1.direction = "ascending"
query_databases(notion, database_id; filter=filter, sorts=[sort_1])

#equivalent to 
filter = Dict(:property => "Name", :title => Dict(:equals => "$name"))
sorts = [Dict(:property=>"Name", :direction=>"ascending")]
print(filter)
query_databases(notion, database_id; filter=body, sorts=sorts)
```



