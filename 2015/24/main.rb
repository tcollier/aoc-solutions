#!/usr/bin/env ruby

Package = Struct.new(:index, :weight, :group)
PACKAGES = $<.map.with_index { Package.new(_2, Integer(_1.chomp)) }
TARGET_WEIGHT = PACKAGES.sum { _1.weight } / 3

def group_packages(packages, target_weight, group_num)
  raise ArgumentError.new('`target` must be non-negative') if target_weight < 0
  return true if target_weight == 0
  packages.each do |package|
    if package.group.nil? && package.weight <= target_weight
      package.group = group_num
      return true if group_packages(packages, target_weight - package.weight, group_num)
      package.group = nil
    end
  end
  false
end

def form_group(packages, target_weight, groups, groupings)
  raise ArgumentError.new('`target` must be non-negative') if target_weight < 0
  if target_weight == 0
    found_group = packages.select { _1.group == group_num }.map(&:weight).sort
    return if found_group in groups
    groups << found_group
    if group_num == 0
    else
      return group_packages(packages, target_weight - package.weight, group_num - 1, groups, groupings)
    end
  end
  packages.each do |package|
    if package.group.nil? && package.weight <= target_weight
      package.group = group_num
      return group_packages(packages, target_weight - package.weight, group_num, groups, groupings)
      package.group = nil
    end
  end
end

def in_three_groups(packages)
  groups = Set.new()
  groupings = []
  target_weight = packages.sum { _1.weight } / 3
  form_group(packages, target_weight, groups, groupings)
  groupings
end

puts in_three_groups(PACKAGES)
