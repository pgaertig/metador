require_relative '../test_helper'

class PathMapperTest < FixturedTest

  it "should not map on no mappings" do
    pm = Metador::Util::PathMapper.new(OpenStruct.new({}))

    out = pm.map_src "/test1/test123.jpg", exists: false
    assert_equal '/test1/test123.jpg', out
  end

  it "should map with matching mapping" do
    pm = Metador::Util::PathMapper.new(
        OpenStruct.new({
            path_mappings: [
                {from: "/test1", to: "/mnt/files"}
            ]}))

    out = pm.map_src "/test1/test123.jpg", exists: false
    assert_equal '/mnt/files/test123.jpg', out
  end

  it "should map once with matching mapping" do
    pm = Metador::Util::PathMapper.new(
        OpenStruct.new({
                           path_mappings: [
                               {from: "/", to: "/opt/"},
                               {from: "/test1", to: "/mnt/files"}
                           ]}))

    out = pm.map_src "/test1/test123.jpg", exists: false
    assert_equal '/opt/test1/test123.jpg', out
  end

  it "should not map if no matching" do
    pm = Metador::Util::PathMapper.new(
        OpenStruct.new({
                           path_mappings: [
                               {from: "/test2", to: "/opt/"},
                               {from: "/test1", to: "/mnt/files"}
                           ]}))

    out = pm.map_src "/foo/test123.jpg", exists: false
    assert_equal '/foo/test123.jpg', out
  end

  it "should map dest" do
    pm = Metador::Util::PathMapper.new(
        OpenStruct.new({
                           path_mappings: [
                               {from: "/test1", to: "/mnt/files"}
                           ]}))

    out = pm.map_dest "/test1/test123.jpg"
    assert_equal '/mnt/files/test123.jpg', out
  end



end