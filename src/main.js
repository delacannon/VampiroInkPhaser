import "pixi";
import "p2";
import Phaser from "phaser";

import BootState from "./states/Boot";
import SplashState from "./states/Splash";
import GameState from "./states/Game";

class Game extends Phaser.Game {
  constructor() {
    super(2048, 1536, Phaser.AUTO, "content", null);

    this.state.add("Boot", BootState, false);
    this.state.add("Splash", SplashState, false);
    this.state.add("Game", GameState, false);

    this.state.start("Boot");
  }
}

window.game = new Game();
