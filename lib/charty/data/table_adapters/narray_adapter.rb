require 'charty/table'
require 'numo/narray'

module Charty
  module TableAdapters
   class NArrayAdapter < Charty::Table
     def initialize(narray, **kwargs)
       @narray = narray
       raise ArgumentError, "ndims must be equal 2" if @narray.ndims != 2

       if kwargs[:columns].nil? || kwargs[:columns].empty?
         kwargs[:columns] = n_columns.times.map {|j| "X#{j}" }
       end

       super(**kwargs)
     end

     def n_rows
       @narray.shape[0]
     end

     def n_columns
       @narray.shape[1]
     end

     def each_row
       return to_enum(:each_row) unless block_given?
       i, n = 0, n_rows
       while i < n
         yield @narray[i, true]
         i += 1
       end
     end

     def [](i, j)
       @narray[i, j]
     end
   end
  end
end
