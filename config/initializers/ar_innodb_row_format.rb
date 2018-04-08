# https://qiita.com/nekoruri/items/a91cc2654e2d0535f7b4

ActiveSupport.on_load :active_record do
  begin
    module ActiveRecord::ConnectionAdapters

      class AbstractMysqlAdapter < AbstractAdapter
        def create_table_with_innodb_row_format(table_name, options = {})
          table_options = options.reverse_merge(:options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC')
          create_table_without_innodb_row_format(table_name, table_options) do |td|
            yield td if block_given?
          end
        end
        alias_method_chain :create_table, :innodb_row_format
      end

    end
  rescue NameError => ex
    # MySQLが使われていないので無視
  end
end
