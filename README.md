# Notion_SDK_JL.jl(WIP)
notion-sdk-jl is a simple and easy to use client library for the official [Notion API](https://developers.notion.com/).

Still working on it


## Thinking the `api`
### Python
when retrieve `blocks`, `pages` `databases`, in `notion-sdk-py`
```python 
notion = Client(token)
notion.pages.retrive(...)
notion.blocks.retrive(...)
notion.databases.retrive(...)
```
where notion.xxx represent a `endpoint` class 

### Julia
should I try:
**will stick with this for now**

```julia
notion = Client(token)
retrive_page()
retrive_blocks()
retrive_database()
```
or 
```julia
abstract type WrapClient end
wrap(c::WrapClient) = WrapClient.Client
struct DatabaseClient end
struct PageClient end
struct BlockClient end

dc = DatabaseClient(notion)
pc = PageClient(notion)
bc =  BlockClient(notion)
# too superfluous
retrive(dc, database_id, kwargs...) 
retrive(pc, page_id, kwargs...) 
retrive(bc, block_id, kwargs...)
```




