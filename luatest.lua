local Query = vim.treesitter.query
local query = Query.get("python", "highlights")

if not query then
  print("bad query")
  return
end

for id, name in pairs(query.captures) do
  print(id, name)
end
