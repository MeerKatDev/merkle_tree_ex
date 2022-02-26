defmodule MerkleTree.Intermediate do
	@moduledoc false

	defmacro intermediate(lim) do
	  	total_len = 4
	    quote do
	      tx, {[unquote_splicing(for n <- 1..total_len do
	        if n < lim do
	          quote do: unquote(Macro.var(:"x#{n}", nil))
	        else
	          quote do: unquote(Macro.var(nil, nil))
	        end
	      end)], hashes} ->
	        {[unquote_splicing(for n <- 1..total_len do
	        cond do
	          n < lim -> quote do: unquote(Macro.var(:"x#{n}", nil))
	          n == lim -> quote do: unquote(Macro.var(:tx, nil))
	          true -> quote do: unquote(Macro.var(nil, nil))
	        end
	      end)], hashes}
	    end
	end

	defmacro intermediate_debug(empty_lst) do
	    quote do
	    	fn
		      tx, {unquote(empty_lst), hashes} ->
		        {[tx, nil, nil, nil], hashes}

		      tx, {{x0, nil, nil, nil}, hashes} ->
		        {{x0, tx, nil, nil}, hashes}

		      tx, {{x0, x1, nil, nil}, hashes} ->
		        {{x0, x1, tx, nil}, hashes}

		      tx, {lst, hashes} ->
		        {unquote(empty_lst), [sha256(Enum.join(lst) <> tx) | hashes]}
		    end
	    end
	end
end