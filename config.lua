Config = {}

Config.gopostalobje = {  

  vector4(-581.161, -1025.543, 21.330, -2.353),
  vector4(-706.498, -917.697, 18.215, -87.921),
  vector4(-681.411, -894.965, 23.499, 90.719),
  vector4(369.227, -947.660, 28.436,  -91.604),
  vector4(295.896, -591.275, 42.272,  161.097),
  vector4(-397.380, -115.601, 37.684,29.324),
  vector4(-1203.233, -329.109, 36.820,27.369),
  vector4(370.682, 323.607, 102.542, -104.721),
  vector4(20.901, -1350.455, 28.325,  -90.487),
  vector4(-1230.842, -904.015, 11.131,  121.523)

}

Config.maxSpawnAttempts = 5  -- 最大地面检测尝试次数
Config.spawnHeightOffset = 0.5 -- 初始检测高度偏移
 
Config.oxrmbox = {
  'prop_hat_box_06',  
  'bzzz_prop_custom_box_3a',  
  'bzzz_prop_custom_box_1a',
  'bzzz_prop_custom_box_2a',
} 

Config.spawnArea = {
  center = vector3(70.0, 120.0, 79.0),  -- 区域中心坐标
  radius = 5.0,                         -- 生成半径（单位：米）
  minCount = 5,                         -- 最小生成数量
  maxCount = 10                          -- 最大生成数量
}

Config.Pedlocation = {  
    {Cords = vector3(78.9427, 112.5193, 80.2), h = 158.1205},   
}

Config.Postalped = {
    `S_M_M_Postal_01`,
}

Config.vehicle = {
  vector3(60.9892, 124.7706, 79.2272),
  heading = 158.2907
}