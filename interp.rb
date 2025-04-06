require "minruby"

def evaluate(tree, genv, lenv)
  case tree[0]
  when "lit"
    tree[1]
  when "*"
    evaluate(tree[1], genv, lenv) * evaluate(tree[2], genv, lenv)
  when "/"
    evaluate(tree[1], genv, lenv) / evaluate(tree[2], genv, lenv)
  when "+"
    evaluate(tree[1], genv, lenv) + evaluate(tree[2], genv, lenv)
  when "-"
    evaluate(tree[1], genv, lenv) - evaluate(tree[2], genv, lenv)
  when "%"
    evaluate(tree[1], genv, lenv) % evaluate(tree[2], genv, lenv)
  when "**"
    evaluate(tree[1], genv, lenv) ** evaluate(tree[2], genv, lenv)
  when "=="
    evaluate(tree[1], genv, lenv) == evaluate(tree[2], genv, lenv)
  when ">"
    evaluate(tree[1], genv, lenv) > evaluate(tree[2], genv, lenv)
  when ">="
    evaluate(tree[1], genv, lenv) >= evaluate(tree[2], genv, lenv)
  when "<"
    evaluate(tree[1], genv, lenv) < evaluate(tree[2], genv, lenv)
  when "<="
    evaluate(tree[1], genv, lenv) <= evaluate(tree[2], genv, lenv)
  when "func_call"
    args = []
    i = 0
    while tree[i+2]
      args[i] = evaluate(tree[i+2], genv, lenv)
      i += 1
    end
    mhd = genv[tree[1]]
    if mhd[0] = "builtin"
      minruby_call(mhd[1], args)
    end
  when "stmts"
    i = 1
    last = nil
    while tree[i]
      last = evaluate(tree[i], genv, lenv)
      i += 1
    end
    last
  when "var_assign"
    lenv[tree[1]] = evaluate(tree[2], genv, lenv)
  when "var_ref"
    lenv[tree[1]]
  when "if"
    evaluate(tree[1], genv, lenv) ? evaluate(tree[2], genv, lenv) : evaluate(tree[3], genv, lenv)
  when "while"
    while evaluate(tree[1], genv, lenv)
      evaluate(tree[2], genv, lenv)
    end
  when "while2"
    evaluate(tree[2], genv, lenv)
    while evaluate(tree[1], genv, lenv)
      evaluate(tree[2], genv, lenv)
    end
  else
    p("Error")
    p("Can't evaluate : " + tree[0].to_s)
    raise("unknown node")
  end
end

def max(tree)
  p tree
  if tree[0] == "lit"
    tree[1]
  else
    left = max(tree[1])
    right = max(tree[2])
    left >= right ? left : right
  end
end

genv = {"p" => ["builtin", "p"], "raise" => ["builtin", "raise"]}
lenv = {}
str = minruby_load()
tree = minruby_parse(str)
evaluate(tree, genv, lenv)