from functools import wraps

def simple_decorator(func):
  @wraps(func)
  def wrapper(*args, **kwargs):
    print(f"Calling: {func.__name__}!")
    return func(*args, **kwargs)
  return wrapper

@simple_decorator
def greet(name):
  """Greet someone by name"""
  print(f"Hello, {name}!")

print("===== Running simple_decorator:")
print(f"greet.__name__: {greet.__name__}")
print(f"greet.__doc__: {greet.__doc__}")
greet(name='Salman')

print()
#####################################################
#####################################################
#####################################################
def option_decorator(*args, **kwargs):
  def wrapper(func):
    print(f"Calling: {func.__name__}!")
    print(f"ARGS: {args}!")
    print(f"KWARGS: {kwargs}!")
    return func
  return wrapper

print("===== Running option_decorator:")
@option_decorator('--name')
def hello(name):
  """Say hello to someone."""
  print(f"Hello, {name}!")

print(f"hello.__name__: {hello.__name__}")
print(f"hello.__doc__: {hello.__doc__}")
hello(name="Salman")
