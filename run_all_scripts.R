script_paths = list.files('scripts/', full.names = TRUE )

sort(script_paths)

for (script_path in script_paths) {
  source(script_path)
}
