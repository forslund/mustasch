return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 15,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 5,
  nextobjectid = 15,
  properties = {},
  tilesets = {
    {
      name = "snow-tiles",
      firstgid = 1,
      filename = "snow-tiles.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 10,
      image = "snow-tiles.png",
      imagewidth = 320,
      imageheight = 320,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 100,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "background",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "PgAAAD8AAAA+AAAAPwAAAD4AAAA/AAAAPgAAAD8AAAA+AAAAPwAAAD4AAAA/AAAAPgAAAD8AAAA+AAAAPwAAAD4AAAA/AAAAPgAAAD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABLAAAATgAAACkAAAAqAAAAKwAAACwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZAAAAGgAAACkAAAAqAAAAMwAAADQAAAA1AAAANgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkAAAAaAAAAMwAAADQAAAA9AAAAPgAAAD8AAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZAAAADwAAABAAAAAAAAAAAAAAAAAAAAAAAAAAGQAAABoAAAAzAAAANAAAAAAAAAAzAAAANgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkAAAAPAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAZAAAAGgAAADMAAAA0AAAAAAAAADMAAAA2AAAAAAAAAAAAAAAAAAAASwAAAE4AAAAAAAAADwAAAA8AAAAQAAAAAAAAAAAAAAAAAAAAAAAAABkAAAAaAAAAMwAAADQAAAAAAAAAMwAAADYAAAAAAAAAAAAAAEsAAABYAAAAWAAAAE4AAAAPAAAADwAAABAAAAAAAAAAAAAAAAAAAAAAAAAAGQAAABoAAAAzAAAANAAAAAAAAAAzAAAANgAAAAAAAAAAAAAAQQAAAFgAAABYAAAAQgAAAA8AAAAPAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAZAAAAGgAAADMAAAA0AAAAAAAAADMAAAA2AAAAAAAAAAAAAAAAAAAAQQAAAEIAAAAAAAAADwAAAA8AAAAQAAAAAAAAAEsAAABMAAAAAAAAACMAAAAkAAAAMwAAADQAAAAAAAAAMwAAADYAAAAAAAAAAAAAAAAAAABDAAAARAAAAAAAAAAPAAAADwAAABAAAAAAAAAAQQAAAEIAAAAAAAAAGQAAABoAAAAzAAAANAAAAAAAAAAzAAAANgAAAAAAAAAAAAAAAAAAAEMAAABEAAAAAAAAABkAAAAPAAAAEAAAAAAAAABDAAAARAAAAAAAAAAjAAAAJAAAADMAAAA0AAAA"
    },
    {
      type = "tilelayer",
      id = 4,
      name = "foreground",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMQAAADIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7AAAAPAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    },
    {
      type = "objectgroup",
      id = 3,
      name = "ground",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "ceiling",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 640,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 160,
          width = 128,
          height = 96,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 577.333,
          y = 160,
          width = 62.6667,
          height = 318.667,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      id = 2,
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 4,
          name = "player",
          type = "player",
          shape = "rectangle",
          x = 32,
          y = 128,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "block1",
          type = "block",
          shape = "rectangle",
          x = 192,
          y = 160,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["no_rotate"] = true
          }
        },
        {
          id = 6,
          name = "block2",
          type = "block",
          shape = "rectangle",
          x = 459.333,
          y = 199.333,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["no_rotate"] = true
          }
        },
        {
          id = 7,
          name = "rope 1",
          type = "rope",
          shape = "rectangle",
          x = 206.667,
          y = 10.6667,
          width = 6,
          height = 166,
          rotation = 0,
          visible = true,
          properties = {
            ["length"] = 166,
            ["obj1"] = "ceiling",
            ["obj2"] = "block1",
            ["offset"] = 0
          }
        },
        {
          id = 9,
          name = "rope 2",
          type = "rope",
          shape = "rectangle",
          x = 471,
          y = 20.3333,
          width = 6,
          height = 190,
          rotation = 0,
          visible = true,
          properties = {
            ["length"] = 190,
            ["obj1"] = "ceiling",
            ["obj2"] = "block2",
            ["offset"] = 0
          }
        },
        {
          id = 12,
          name = "block3",
          type = "block",
          shape = "rectangle",
          x = 315,
          y = 207.5,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["no_rotate"] = true
          }
        },
        {
          id = 13,
          name = "rope 3",
          type = "rope",
          shape = "rectangle",
          x = 326.667,
          y = 28.5002,
          width = 6,
          height = 190,
          rotation = 0,
          visible = true,
          properties = {
            ["length"] = 190,
            ["obj1"] = "ceiling",
            ["obj2"] = "block3",
            ["offset"] = 0
          }
        },
        {
          id = 14,
          name = "level3",
          type = "exit",
          shape = "rectangle",
          x = 614,
          y = 44,
          width = 27,
          height = 116,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
