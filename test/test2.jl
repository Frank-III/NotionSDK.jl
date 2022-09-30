using Test
using EasyConfig
using DotEnv
using NotionSDK
using JSON3
using Chain


DotEnv.config("test/.env");

NOTION_TOKEN = ENV["NOTION_TOKEN"];
database_id = ENV["database_id"];
final_paper_page = ENV["final_paper_page"];
final_database = ENV["final_database"]
user_id = ENV["user_id"];
page_id = ENV["page_id"];
notion = Client(NOTION_TOKEN)

list_users(notion)[:results] |> JSON3.pretty

retrieve_page(notion, page_id) |> JSON3.pretty


filter = Dict(Dict(:property => "Name", :title => Dict(:equals => "TSx.jl")))
sorts = [Dict(:property => "Name", :direction => "ascending")] #pick(f(;filter=filter, sorts=sorts), :filter, :sorts)
blocks = list_block_children(notion, query_databases(notion, database_id; filter = filter, sorts = sorts)[:results][1][:id])
blocks[:results]

blocks_id= list_block_children(notion, query_databases(notion, database_id; filter = Dict(Dict(:property=>"Name", :title => Dict(:equals => "Tsx.jl"))), sorts = sorts)[:results][1][:id])
append_block_children(no)

list_block_children(notion, final_paper_page)[:results]
blocks_long = query_databases(notion, final_database; filter=Dict(Dict(:property => "Name", :title=> Dict(:equals => "开题报告"))))[:results][1][:id]
JSON3.write("test/final_paper.json",list_block_children(notion, blocks_long)[:results])
query_database(notion, database_id; filter = filter,)
list_block_children(notion, blocks_long)[:results][12]|> JSON3.pretty
list_block_children(notion, blocks_long)[:results][13]|> JSON3.pretty
list_block_children(notion, blocks_long)[:results][35]|> JSON3.pretty
list_block_children(notion, blocks_long)[:results][31]|> JSON3.pretty
list_block_children(notion, "b1a58768-1a6a-4f6d-910f-29e6fd1c6117")[:results]
list_block_children(notion, list_block_children(notion, blocks_long)[:results][11][:id])[:results]# |> JSON3.pretty


list_block_children(notion, "b1707658-37da-4763-82f7-86037517fdc7")[:results] |> JSON3.pretty
list_block_children(notion, "0182a7b8-375b-4e7e-97a4-4eb67aee242f")[:results]
