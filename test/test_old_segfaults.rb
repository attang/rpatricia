require 'test/unit'
require 'rpatricia'

# things that used to segfault before the introduction of
# Patricia::Node will now raise NoMethodError
class TestOldSegfaults < Test::Unit::TestCase

  def test_used_to_segfault
    assert_raises(NoMethodError) { Patricia.new.data }
  end

  def test_node_method
    t = Patricia.new
    t.add('10.0.0.0/8', 'big_lan')
    if matched = t.match_best('10.1.2.3')
      assert_kind_of Patricia::Node, matched
      assert_equal 'big_lan', matched.data
      assert_raises(NoMethodError) { matched.destroy }
    end
  end

  def test_empty_show_nodes
    assert_nothing_raised do
      t = Patricia.new
      t.show_nodes
    end
  end

  def test_empty_num_nodes
    t = Patricia.new
    assert_equal 0, t.num_nodes
  end

  def test_v6_v4_mismatch_search_best
    t = Patricia.new
    assert_raises(ArgumentError) { t.search_exact("::1/128") }
  end

  def test_v6_v4_mismatch_search_exact
    t = Patricia.new
    assert_raises(ArgumentError) { t.search_exact("::1/128") }
  end

  def test_gc_ordering_segfault
    added = []
    100000.times do
      tmp = Patricia.new
      added << tmp.add('8.8.8.8')
    end
  end
end
