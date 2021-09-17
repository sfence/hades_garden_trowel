
garden_trowel = {
  translator = minetest.get_translator("garden_trowel"),
  
  wet_garden_soils = {["composting:garden_soil_wet"] = true},
  dirt_with_grass_nodes = {
    ["hades_core:dirt_with_grass"] = {
        new_node = "hades_core:dirt_with_grass_l2",
        drop_item = "hades_garden_trowel:grass_divot",
      },
    ["hades_core:dirt_with_grass_l3"] = {
        new_node = "hades_core:dirt_with_grass_l1",
        drop_item = "hades_garden_trowel:grass_divot",
      },
    ["hades_core:dirt_with_grass_l2"] = {
        new_node = "hades_core:dirt",
        drop_item = "hades_garden_trowel:grass_divot",
      },
  },
}

local S = garden_trowel.translator;

minetest.register_craftitem("hades_garden_trowel:grass_divot", {
    description = S("Grass Divot"),
    _tt_help = S("Place me on wet garden soil."),
    inventory_image = "garden_trowel_grass_divot.png",
    
    on_place = function (itemstack, placer, pointed_thing)
      local node = minetest.get_node(pointed_thing.under);
      if garden_trowel.wet_garden_soils[node.name] then
        minetest.set_node(pointed_thing.under, {name="hades_core:dirt_with_grass_l1"})
        itemstack:take_item(1);
      end
      return itemstack;
    end,
  })

local function trowel_on_use(itemstack, user, pointed_thing)
  local node = minetest.get_node(pointed_thing.under);
  local new_data = garden_trowel.dirt_with_grass_nodes[node.name];
  if new_data then
    local def = itemstack:get_definition();
    itemstack:add_wear(def._trowel_wear);
    minetest.set_node(pointed_thing.under, {name=new_data.new_node});
    local inv = user:get_inventory();
    local leftover = inv:add_item("main", new_data.drop_item);
    if (leftover:get_count()>0) then
      minetest.add_item(pointed_thing.under, leftover);
    end
  end
  return itemstack;
end

local trowels = {
  wood = {
    desc = "Wooden",
    handle = "wood",
    handle_mat = "group:stick",
    body_mat = "group:wood",
    _trowel_wear = 6000,
  },
  stone = {
    desc = "Stone",
    handle = "wood",
    handle_mat = "group:stick",
    body_mat = "group:stone",
    _trowel_wear = 3000,
  },
  bronze = {
    desc = "Bronze",
    handle = "wood",
    handle_mat = "group:stick",
    body_mat = "hades_core:bronze_ingot",
    _trowel_wear = 2000,
  },
  iron = {
    desc = "Iron",
    handle = "wood",
    handle_mat = "group:stick",
    body_mat = "hades_core:steel_ingot",
    _trowel_wear = 1500,
  },
  prism = {
    desc = "Prism",
    handle = "iron",
    handle_mat = "hades_core:steel_ingot",
    body_mat = "hades_core:prismatic_gem",
    _trowel_wear = 600,
  },
  mese = {
    desc = "Mese",
    handle = "iron",
    handle_mat = "hades_core:steel_ingot",
    body_mat = "hades_core:mese_crystal",
    _trowel_wear = 200,
  },
}

for material, data in pairs(trowels) do
  minetest.register_tool("hades_garden_trowel:trowel_"..material, {
      description = S(data.desc.." Garden Trowel"),
      inventory_image = "garden_trowel_trowel_head_"..material..".png^garden_trowel_trowel_handle_"..data.handle..".png",
      sound = {breaks = "default_tool_breaks"},
      groups = {trowel = 1},
      _trowel_wear = data._trowel_wear,
      
      on_use = trowel_on_use,
    })
  minetest.register_craft({
      output = "hades_garden_trowel:trowel_"..material,
      recipe = {
        {data.handle_mat},
        {data.body_mat}
      },
    })
end

