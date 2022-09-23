# Notion_SDK_JL.jl(WIP)
notion-sdk-jl is a simple and easy to use client library for the official [Notion API](https://developers.notion.com/).

Still working on it.
Currently: The return is HTTP request results, should parse the result and return json or dict. (TO DO)

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
retrieve_user(notion, user_id)

retrieve_page(notion, page_id)
# need to fix 
body = Config()
body.filter.property = "Name"
body.filter.title.equals = some_name
print(body)
query_databases(notion, database_id; filter=body)

#equivalent to 
body = Dict(:filter=> Dict(:property => "Name", :title => Dict(:equals => "$name")))
print(body)
query_databases(notion, database_id; filter=body)
```



