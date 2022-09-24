# test api
@test typeof(list_users(notion)) == JSON3.Object
@test typeof(get_me(notion)) == JSON3.Object
@test retrieve_user(notion, user_id) == JSON3.Object
page_ = retrieve_page(notion, page_id)
@test typeof(page_) == JSON3.Object
@test page_[:object] == "page"

function parse_input1(name; kwargs...)
    filter = Config()
    filter.property = "Name"
    filter.title.equals = name
    print(filter)
    sorts = [Config()]
    sorts[1].property = "Name"
    sorts[1].direction = "ascending"
    query_databases(notion, database_id; filter=filter, sorts=sorts)
end

database_page = parse_input1("Lux.jl")
@test database_page[:object] = "list"
@test typeof(database_page) == JSON3.Object
@test database_page[:results] == JSON3.Array

function parse_input2(name; kwargs...)
    filter = Dict(Dict(:property => "Name", :title => Dict(:equals => "$name")))
    sorts = [Dict(:property=>"Name", :direction=>"ascending")]
    #pick(f(;filter=filter, sorts=sorts), :filter, :sorts)
    query_databases(notion, database_id; filter=filter, sorts=sorts)
end

database_page2 = parse_input2("Lux.jl")
@test database_page[:object] = "list"
@test typeof(database_page2) == JSON3.Object
@test database_page2[:results] == JSON3.Array

data_base_empty = parse_input2("NotionSDK.jl")
@test typeof(database_page2) == JSON3.Object
@test isempty(database_page2[:results]) == true
