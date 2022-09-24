module notion_sdk_jl

using Logging
using EasyConfig
using JSON3
import JSON:json
using HTTP

include("clients.jl")

export
    Client, AsyncClient,
	retrieve_user, list_users, get_me,
	create_page, retrieve_page, retrieve_page_properties, update_page,
	list_databases, query_databases, retrieve_databases, create_databases,update_databases,
	retrieve_block, update_block,
    list_block_children, append_block_children,
    search,
    create_comment, list_comments


end # module notion_sdk_jl
