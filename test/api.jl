# test api
@test list_users(notion) isa JSON3.Object
@test get_me(notion) isa JSON3.Object
@test retrieve_user(notion, user_id) isa JSON3.Object
page_ = retrieve_page(notion, page_id)
@test page_ isa JSON3.Object
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
@test database_page[:object] == "list"
@test database_page isa JSON3.Object
@test database_page[:results] isa JSON3.Array

function parse_input2(name; kwargs...)
    filter = Dict(Dict(:property => "Name", :title => Dict(:equals => "$name")))
    sorts = [Dict(:property=>"Name", :direction=>"ascending")]
    #pick(f(;filter=filter, sorts=sorts), :filter, :sorts)
    query_databases(notion, database_id; filter=filter, sorts=sorts)
end

database_page2 = parse_input2("Lux.jl")
@test database_page[:object] == "list"
@test database_page2 isa JSON3.Object
@test database_page2[:results] isa JSON3.Array

data_base_empty = parse_input2("NotionSDK.jl")
@test database_page2 isa JSON3.Object
@test database_page2[:results] isa JSON3.Array
