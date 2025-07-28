import inspect

SUCCESS_LEVEL = 32

def call_func_with_matching_args(func, args):
  """
  Calls `func` with only the arguments it accepts from `args`.
  """
  sig = inspect.signature(func)

  # filter only matching args
  filtered_kwargs = {
    k: v for k, v in vars(args).items()
    if k in sig.parameters
  }

  return func(**filtered_kwargs)
