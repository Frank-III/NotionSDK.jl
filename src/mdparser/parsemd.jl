import Base.@kwdef

## Some limitations:
## 1. some nested object is not allowed in Markdown
## 2. Toggle is not implement in Julia

"""
The most important structure here
{
    "type": "paragraph",
    "paragraph": {
    "rich_text": [{
        "type": "text",
        "text": {
        "content": "Lacinato kale",
        "link": null
        }
    }],
    "children":[{...}]
  }
}
"""

Base.@kwdef struct NotionBlock{b}
    block::Config = Config(type=b)
    content
end


function parse_md end

parse_md(text::String) = parse_md(Markdown.parse(text))
#parse_md(x; kwargs...)::String = string(x)

function parse_md(ns::AbstractString; kwargs...)
    Config(
        type = :text,
        text = (; content = ns),
        )
end

function parse_md(text::Markdown.MD; kwargs...)
    elements = parse_md.(text.content; indent = 1, kwargs...)
    return elements
end

function parse_md(bold::Markdown.Bold; kwargs...)
    Config(
        type = :text,
        text = (; content = bold.text),
        annotations = (; bold = true)
        )
end

function parse_md(italic::Markdown.Italic; kwargs...)
    Config(
        type = :text,
        text = (; content = italic.text),
        annotations = (; italic = true)
    )
end

"""## It is an exmple of `Heading` with **Bold** and *Italic*"""
function parse_md(text::Markdown.Header{l}, kwargs...) where {l} ## return a vector
    NotionBlock{Symbol("heading_",l)}(content=parse_md.(text.text; inline=true))
end

function parse_md(code::Markdown.Code; inline=false, indent=1, kwargs...)
    indent > 2 && inline == false && return
    content = Config(
        type = :code,
        text = (; content = code.code ),
        annotations = (; code = true)
    )
    length(code.language) > 0 && (content.language = code.language)
    inline ? content : NotionBlock{:code}(content=content)
end

function parse_md(math::Markdown.LaTeX; inline=false, indent=1, kwargs...)
    #have to work on the inline and block case
    indent > 2 && inline == false && return
    content = Config(
        type = :equation,
        equation = (; expression = math.formula)
    )
    content
end

function parse_md(lnk::Markdown.Link;)
end


function parse_md(paragraph::Markdown.Paragraph; indent= 1, inline = false, kwargs...)
    #indent > 2 && return
    content = parse_md.(paragraph.content; indent=indent+1, inline=true)
    return inline ? content : NotionBlock{:paragraph}(content=content)
end

function parse_md(list::Markdown.List; indent = 1, kwargs...)
    indent > 2 && return
    list_type = Markdown.isordered(list) ? (:numbered_list_item) : (:bulleted_list_item)
    # not have to specify inline to be true as code type could still be block
    #content = parse_md.(list.items; inline=true, indent=indent+1) # not correct
    #NotionBlock{isordered(list) ? (:numbered_list_item) : (:bulleted_list_item)}(content=content)
    map(list.items) do item
        res = parse_md.(item; inline = true, indent=indent+1)
        #fst, rst... = parse_md.(item; inline = true, indent=indent+1)
        NotionBlock{list_type}(content = res)
    end
end

function parse_md(qt::Markdown.BlockQuote; indent =1, kwargs...)
    indent > 2 && return
    content = collect(Iterators.flatten(parse_md.(qt.content; inline = true)))
    NotionBlock{:quote}(content=content)
end

function (nb::NotionBlock{:numbered_list_item})(::Val{true})
    nb.block[:numbered_list_item].rich_text = nb.content
    nb.block
end


function (nb::NotionBlock{:bulleted_list_item})(::Val{true})
    nb.block[:bulleted_list_item].rich_text = nb.content
    nb.block
end

@inline islist(nb::NotionBlock) = false
@inline islist(nb::NotionBlock{:numbered_list_item}) = true
@inline islist(nb::NotionBlock{:bulleted_list_item}) = true


@inline (nb::Config)() = nb

function (nb::NotionBlock{b})() where {b}
    nb.block[b].rich_text = nb.content
    @show nb.block
end
