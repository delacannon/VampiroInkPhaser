import { State } from "phaser";
import { loadStory } from "../utils";

export default class extends State {
  init() {}
  preload() {}

  create() {
    //Create story object
    this.story = loadStory();
    //Background image
    this.bg_ui = this.add.image(0, 0, "bg_ui");

    //Text paragraph container
    this.text_paragraph = this.add.text(768, 128, "", {
      fontSize: "38px",
      font: "Roboto Mono",
      fill: "#fff",
      wordWrap: true,
      wordWrapWidth: 1216,
      align: "left",
    });
    this.text_paragraph.alpha = 0;

    //Text current room container
    this.text_localizacion = this.add.text(390, 66, "", {
      fontSize: "40px",
      font: "Roboto Mono",
      fill: "#9c3333",
      wordWrap: true,
      wordWrapWidth: 1200,
      align: "center",
    });
    this.text_localizacion.anchor.set(0.5);
    this.text_localizacion.alpha = 1;

    //Text inventory label container
    this.text_label = this.add.text(96, 1452, "", {
      fontSize: "32px",
      font: "Roboto Mono",
      fill: "#ffffff",
      wordWrap: true,
      wordWrapWidth: 1200,
      align: "center",
    });

    //background current room
    this.img_bg = this.add.image(400, 432, "");

    this.choicesGroup = this.add.group();
    this.inventoryGroup = [];

    this.inventory = [];
    this.grid = [];

    let ss = 0;
    for (let i = 0; i < 3; i++) {
      for (let j = 0; j < 3; j++) {
        let m = this.add.image(128 + j * 192, 864 + i * 192, "dummy");
        m.alpha = 0.1;
        m.inputEnabled = true;
        m.id = ss;
        this.grid.push(m);
        ss++;
      }
    }

    this.picup = this.add.audio("picup");
    this.ambient = this.add.audio("ambient", true);

    this.ambient.play();

    //Custom external functions declared in Ink file

    //Play sounds from Ink file {snd_fx()}
    this.story.BindExternalFunction("snd_fx", () => {
      this.picup.play();
    });

    //Display image from Ink file {show_image("imageName")}
    this.story.BindExternalFunction("show_image", (key) => {
      this.createImage(key);
    });

    //Display background image from Ink file {show_image_bg("imageName")}
    this.story.BindExternalFunction("show_image_bg", (key) => {
      this.createImageBG(key);
    });

    //Change inventory item state {change_inventory_state("imageName")}
    this.story.BindExternalFunction("change_inventory_state", (key, change) => {
      this.inventory.forEach(function (s) {
        if (s.name == key) {
          let item = this.inventoryGroup[s.id];
          item.name = change;
          item.loadTexture(change + "_thumb");
        }
      }, this);
    });

    //Add item to inventory array list {add_to_inventory("item",state)}
    this.story.BindExternalFunction("add_to_inventory", (item, state) => {
      this.inventory.push({
        id: this.inventory.length,
        name: item,
        state: state,
      });

      this.createInventoryItem(item, this.inventory.length - 1);
    });
    //Hide image from Ink file to phaser image {hide_image("imageName")}
    this.story.BindExternalFunction("hide_image", () => {
      if (this.img) {
        let tp2 = this.add.tween(this.img);
        tp2.to(
          {
            alpha: 0,
          },
          1,
          Phaser.Easing.Circular.Out
        );
        tp2.onComplete.add(function () {
          this.img.destroy();
        }, this);
        tp2.start();
      }
    });

    //Starts story
    this.continueStory();
  }

  //Set global variables from phaser to story
  setGameVariable(txt, newValue) {
    this.story.variablesState._globalVariables.set(txt, newValue);
    //this.story.variablesState._globalVariables[txt]._value = newValue;
  }
  //Get global variables from story
  getGameVariable(txt) {
    return this.story.variablesState._globalVariables.get(txt).value;
    //return this.story.variablesState._globalVariables[txt]._value
  }
  //Set temp variables from phaser to story
  setTempVariable(txt, newValue) {
    this.story.variablesState.GetRawVariableWithName(txt, 1)._value = newValue;
  }
  //Get temp variables from story
  getTempVariable(txt) {
    return this.story.variablesState.GetRawVariableWithName(txt, 1).value;
  }

  createInventoryItem(item, id) {
    let d = this.grid[id];
    let inventory_item = this.add.sprite(d.x, d.y, item + "_thumb");
    inventory_item.id = id;
    inventory_item.name = item;
    inventory_item.inputEnabled = true;
    inventory_item.events.onInputOver.add(this.inventory_over, inventory_item);
    inventory_item.events.onInputOut.add(this.inventory_out, inventory_item);
    inventory_item.events.onInputDown.add(this.inventory_goto, inventory_item);
    this.inventoryGroup.push(inventory_item);
  }

  inventory_over() {
    game.state.callbackContext.text_label.text = this.name;
  }

  inventory_out() {
    game.state.callbackContext.text_label.text = "";
  }

  inventory_goto() {
    let name = this.name.replace(/ /g, "_");
    game.state.callbackContext.continueStory(name + "_obj");
  }

  createImageBG(image) {
    if (this.img_bg.key != image) {
      this.img_bg.anchor.set(0.5);
      this.img_bg.alpha = 0;
      this.img_bg.loadTexture(image);
      let tp2 = this.add.tween(this.img_bg);
      tp2.to(
        {
          alpha: 1,
        },
        600,
        Phaser.Easing.Circular.Out
      );
      tp2.start();
    }
  }

  createImage(image) {
    this.img = this.add.image(400, 432, image);
    this.img.anchor.set(0.5);
    this.img.alpha = 0;
    let tp2 = this.add.tween(this.img);
    tp2.to(
      {
        alpha: 1,
      },
      600,
      Phaser.Easing.Circular.Out
    );
    tp2.start();
  }

  createParagraphText(text, choices) {
    // Get text paragraph
    this.text_paragraph.text = text;
    this.text_paragraph.alpha = 0;

    // Create choices list
    choices.forEach(function (choice, i) {
      this.bg_choice = this.add.sprite(768, 2000, "bg_choice");
      this.bg_choice.inputEnabled = true;
      this.bg_choice.alpha = 0;

      this.text_choice = this.add.text(614, 32, choice.text, {
        fontSize: "40px",
        fill: "#9c3333",
        wordWrap: true,
        wordWrapWidth: 1216,
        align: "center",
      });
      this.text_choice.font = "Roboto Mono";
      this.text_choice.anchor.set(0.5);

      this.bg_choice.addChild(this.text_choice);

      let tp2 = this.add.tween(this.bg_choice);
      tp2.to(
        {
          y: 768 + i * 96,
          alpha: 1,
        },
        600,
        Phaser.Easing.Circular.Out,
        true,
        i * 150
      );
      tp2.start();

      this.bg_choice.events.onInputDown.add(function () {
        this.story.ChooseChoiceIndex(choice.index);
        this.choicesGroup.callAll("kill");
        let tp222 = this.add.tween(this.text_paragraph);
        tp222.to(
          {
            alpha: 0,
          },
          300,
          Phaser.Easing.Circular.Out
        );
        tp222.onComplete.add(function () {
          this.continueStory();
        }, this);
        tp222.start();
      }, this);

      this.choicesGroup.add(this.bg_choice);
      let choiceAlpha = this.add.tween(this.text_choice);
      choiceAlpha.to(
        {
          alpha: 1,
        },
        1000,
        Phaser.Easing.Circular.In
      );
      choiceAlpha.start();

      i++;
    }, this);
    //Tween paragraph
    let tp = this.add.tween(this.text_paragraph);
    tp.to(
      {
        alpha: 1,
      },
      1000,
      Phaser.Easing.Circular.Out
    );
    tp.start();

    this.choicesGroup.forEach(function (s) {
      s.events.onInputOver.add(function () {
        s.children[0].fill = "#ffffff";
      }, this);

      s.events.onInputOut.add(function () {
        s.children[0].fill = "#9c3333";
      }, this);
    });
    //Tween paragraph
    let tp22 = this.add.tween(this.text_paragraph);
    tp22.to(
      {
        alpha: 1,
      },
      800,
      Phaser.Easing.Linear.Out
    );
    tp22.start();
  }

  continueStory(jump) {
    let texto = "";

    if (jump != null || jump != undefined) {
      this.story.ChoosePathString(jump);
      this.choicesGroup.callAll("kill");
    }

    //Fetch story data from vampiro.json
    while (this.story.canContinue) {
      let paragraphText = this.story.Continue();

      texto += paragraphText + "\n";
      this.text_localizacion.text = this.getGameVariable("current_name");

      if (!this.story.canContinue) {
        this.createParagraphText(texto, this.story.currentChoices);
      }
    }
  }
}
