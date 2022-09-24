using Test
using EasyConfig
using DotEnv


DotEnv.config("test/.env");

NOTION_TOKEN = ENV["NOTION_TOKEN"];
database_id = ENV["database_id"];
user_id = ENV["user_id"];
page_id = ENV["page_id"];
notion = Client(NOTION_TOKEN)


@test_set "API" begin
    include("api.jl")
end
