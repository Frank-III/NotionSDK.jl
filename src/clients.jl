include("utils.jl")

# switch to EasyConfig
@with_kw struct ClientOptions
	#auth::String = nothing
	#notion_version::String = "2022-06-28"
	#conten_type::String = "application/json" # seems to be important
	header::Config = Config(auth=nothing, notion_version="2022-06-28", conten_type="application/json")
	base_url::String = "https://api.notion.com/v1/"
	timeout_ms::Int = 60_000
end

# would probablity move to utils
const HEADER_NAME = ["Authorization", "Notion-Version", "Content-Type"] # shoule we set HADER_NAME?

function _parse_header(headers::Config)
    return HEADER_NAME .=> collect(values(headers))
end

abstract type BaseClient end

struct Client
  header::Config = Config(auth=nothing, notion_version="2022-06-28", conten_type="application/json")
	base_url::String = "https://api.notion.com/v1/"
	timeout_ms::Int = 60_000
	#log_level::Int= nothing
	#check: if this work?
	function Client(auth::String)
		c = new()
		c.header.auth = auth
		return c
	end
end


function _build_request(client::BaseClient, method::String, path::String; body, query, auth=nothing)
	auth && client.header.auth = "Bearer $(auth)"
	() -> HTTP.request(method, client.base_url * path ,_parse_header(client.header), body=Dict(body...), query=query)
end

function make_request(client::BaseClient, method::String, path::String; body=nothing, query=nothing, auth=nothing)
	try
		response = _build_request(client, method, path; body=body, query=query, auth=auth)()
	catch
		pass
	end
	_parse_response(response)
end



## User Functions
function retrieve_user(notion::BaseClient, user_id::String; kwargs...)
	make_request(notion, "GET", "users/$(user_id)";auth=kwargs.auth)
end

function list_users(notion::BaseClient; kwargs...)
	make_request(notion, "GET", "users";
							query= pick(kwargs, :start_cursor, :page_size);
							auth=get_auth(kwargs))
end

get_me(notion::BaseClient; kwargs...) = make_request(notion, "GET", "users/me"; auth=get_auth(kwargs))


## Page Functions
function create_page(notion::BaseClient; kwargs...)
	make_request(notion, "POST", "pages";
							body=pick(kwargs, :parent, :properties, :children, :icon, :cover),
							auth=get_auth(kwargs))
end

retrieve_page(notion::BaseClient, page_id::String; kwargs...) = make_request(notion, "GET", "pages/$(page_id)"; auth=get_auth(kwargs))

function update_page(notion::BaseClient, page_id::String; kwargs...)
	make_request(notion, "PATCH", "pages/$(page_id)";
							body=pick(kwargs, :achieved, :properties, :icon, :cover),
							auth=get_auth(kwargs))
end

function retrieve_page_properties(notion::BaseClient, page_id::String, property_id::String; kwargs...)
	make_request(notion, "GET", "pages/$(page_id)/properties/$(property_id)";
							query=pick(kwargs, :start_cursor, :page_size),
							auth=get_auth(kwargs))
end

## Database Functions
function list_databases(notion::BaseClient; kwargs...)
	make_request(notion, "GET", "databases";
							query=pick(kwargs, :start_cursor, :page_size),
							auth=get_auth(kwargs))
end

function query_databases(notion::BaseClient, database_id::String; kwargs...)
	make_request(notion, "POST", "databases/$(database_id)/query";
							body=pick(kwargs, :filter, :sort, :start_cursor, :page_size),
							auth=get_auth(kwargs))
end

function retrieve_databases(notion::BaseClient, database_id::String; kwargs...)
	make_request(notion, "POST", "databases/$(database_id)/query";
							body=pick(kwargs, :filter, :sort, :start_cursor, :page_size),
							auth=get_auth(kwargs))
end

function create_databases(notion::BaseClient; kwargs...)
	make_request(notion, "POST", "databases/$(database_id)";
							body=pick(kwargs, :parent, :title, :properties, :icon, :cover),
							auth=get_auth(kwargs))
end

function update_databases(notion::BaseClient, database_id::String; kwargs...)
	make_request(notion, "PATCH", "databases/$(database_id)";
							body=pick(kwargs, :achieved, :properties, :icon, :cover),
							auth=get_auth(kwargs))
end


## Block Functions
retrieve_block(notion::BaseClient, block_id::String; kwargs...) = make_request(notion, "GET", "block/$(block_id)"; auth=get_auth(kwargs))

function update_block(notion::BaseClient, block_id::String; kwargs...)
	make_request(notion, "PATCH", "blocks/$(block_id)";
							body=pick(kwargs,
							:embed,
							:type,
							:archived,
							:bookmark,
							:image,
							:video,
							:pdf,
							:file,
							:audio,
							:code,
							:equation,
							:divider,
							:breadcrumb,
							:table_of_contents,
							:link_to_page,
							:table_row,
							:heading_1,
							:heading_2,
							:heading_3,
							:paragraph,
							:bulleted_list_item,
							:numbered_list_item,
							:quote,
							:to_do,
							:toggle,
							:template,
							:callout,
							:synced_block,
							:table
							),
							auth=get_auth(kwargs))












struct AsyncClient
	options::ClientOptions
end
