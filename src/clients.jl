include("utils.jl")

# would probablity move to utils
const HEADER_NAME = ["Authorization", "Notion-Version", "Content-Type"] # shoule we set HADER_NAME?

abstract type BaseClient end

struct Client <: BaseClient
    header::Config
    base_url::String
    timeout_ms::Int
    #log_level::Int= nothing
    #check: if this work?
    function Client(auth::String = nothing)
        new(
            Config(
                auth = auth,
                notion_version = "2022-06-28",
                content_type = "application/json",
            ),
            "https://api.notion.com/v1/",
            60_000,
        )
    end
end

#function Base.show(io, Client::BaseClient)
#end


function _build_request(client::BaseClient, method::String, path::String; body, query, auth)
    !isnothing(auth) && (client.header.auth = "Bearer $(auth)")
    @show json(body)
    @show query
    () -> HTTP.request(
        method,
        client.base_url * path,
        _parse_header(client.header),
        body = json(body),
        query = query,
    )
end

function make_request(
    client::BaseClient,
    method::String,
    path::String;
    body = Dict(),
    query = Dict(),
    auth = nothing,
)
    try
        response =
            _build_request(client, method, path; body = body, query = query, auth = auth)()
        return _parse_response(response)
    catch e
        return HTTP.Response(400, "Error: $e")
    end
end

_parse_response(response) = JSON3.read(response.body)


## User Functions
function retrieve_user(notion::BaseClient, user_id::String; kwargs...)
    make_request(notion, "GET", "users/$(user_id)"; auth = auth = get_auth(kwargs))
end

function list_users(notion::BaseClient; kwargs...)
    make_request(
        notion,
        "GET",
        "users";
        query = pick(kwargs, :start_cursor, :page_size),
        auth = get_auth(kwargs),
    )
end

get_me(notion::BaseClient; kwargs...) =
    make_request(notion, "GET", "users/me"; auth = get_auth(kwargs))


## Page Functions
function create_page(notion::BaseClient; kwargs...)
    make_request(
        notion,
        "POST",
        "pages";
        body = pick(kwargs, :parent, :properties, :children, :icon, :cover),
        auth = get_auth(kwargs),
    )
end

retrieve_page(notion::BaseClient, page_id::String; kwargs...) =
    make_request(notion, "GET", "pages/$(page_id)"; auth = get_auth(kwargs))

function update_page(notion::BaseClient, page_id::String; kwargs...)
    make_request(
        notion,
        "PATCH",
        "pages/$(page_id)";
        body = pick(kwargs, :achieved, :properties, :icon, :cover),
        auth = get_auth(kwargs),
    )
end

function retrieve_page_properties(
    notion::BaseClient,
    page_id::String,
    property_id::String;
    kwargs...,
)
    make_request(
        notion,
        "GET",
        "pages/$(page_id)/properties/$(property_id)";
        query = pick(kwargs, :start_cursor, :page_size),
        auth = get_auth(kwargs),
    )
end

## Database Functions
function list_databases(notion::BaseClient; kwargs...)
    notion.header.notion_version !== "2021-08-16" && error("this function is deprecated")
    make_request(
        notion,
        "GET",
        "databases";
        query = pick(kwargs, :start_cursor, :page_size),
        auth = get_auth(kwargs),
    )
end

function query_databases(notion::BaseClient, database_id::String; kwargs...)
    make_request(
        notion,
        "POST",
        "databases/$(database_id)/query";
        body = pick(kwargs, :filter, :sorts, :start_cursor, :page_size),
        auth = get_auth(kwargs),
    )
end

function retrieve_databases(notion::BaseClient, database_id::String; kwargs...)
    make_request(
        notion,
        "POST",
        "databases/$(database_id)/query";
        body = pick(kwargs, :filter, :sorts, :start_cursor, :page_size),
        auth = get_auth(kwargs),
    )
end

function create_databases(notion::BaseClient; kwargs...)
    make_request(
        notion,
        "POST",
        "databases/$(database_id)";
        body = pick(kwargs, :parent, :title, :properties, :icon, :cover),
        auth = get_auth(kwargs),
    )
end

function update_databases(notion::BaseClient, database_id::String; kwargs...)
    make_request(
        notion,
        "PATCH",
        "databases/$(database_id)";
        body = pick(kwargs, :achieved, :properties, :icon, :cover),
        auth = get_auth(kwargs),
    )
end

## Block Functions
retrieve_block(notion::BaseClient, block_id::String; kwargs...) =
    make_request(notion, "GET", "blocks/$(block_id)"; auth = get_auth(kwargs))

function update_block(notion::BaseClient, block_id::String; kwargs...)
    make_request(
        notion,
        "PATCH",
        "blocks/$(block_id)";
        body = pick(
            kwargs,
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
            :table,
        ),
        auth = get_auth(kwargs),
    )
end


## Block children functions
function append_block_children(notion::BaseClient, block_id::String; kwargs...)
    make_request(
        notion,
        "PATCH",
        "blocks/$(block_id)/children";
        body = pick(kwargs, :children),
        auth = get_auth(kwargs),
    )
end

function list_block_children(notion::BaseClient, block_id::String; kwargs...)
    make_request(
        notion,
        "GET",
        "blocks/$(block_id)/children";
        query = pick(kwargs, :start_cursor, :page_size),
        auth = get_auth(kwargs),
    )
end

## Search function

function search(notion::BaseClient, block_id::String; kwargs...)
    make_request(
        notion,
        "POST",
        "search";
        query = pick(kwargs, :query, :sort, :filter, :start_cursor, :page_size),
        auth = get_auth(kwargs),
    )
end

## Comment function
function create_comment(notion::BaseClient; kwargs...)
    make_request(
        notion,
        "POST",
        "comments";
        query = pick(kwargs, :parent, :discussion_id, :rich_text),
        auth = get_auth(kwargs),
    )
end

function list_comments(notion::BaseClient; kwargs...)
    make_request(
        notion,
        "GET",
        "comments";
        query = pick(kwargs, :block_id, :start_cursor, :page_size),
        auth = get_auth(kwargs),
    )
end



struct AsyncClient <: BaseClient
    pass::Any
end
