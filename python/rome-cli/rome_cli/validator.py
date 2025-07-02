def validate_required_module(module, name, functions):
  # functions = ["add_args", "run_app", "register_subparser"]
  for fn in functions:
    if not hasattr(module, fn):
      raise ImportError(f"{name} missing required function: `{fn}()`")
