# Balluvar
This is a simple mockup of a larger game designed to test mechanics and features. It is fully playable and functionable with some of the mechanics and systems set in place. My plan is to expand the game through slow and gradual progress into a story-based RPG with bosses and upgrades and the like (or maybe just a stupid mobile game if I burn out ..)

<figure class="video_container">
  <iframe src="BalluvarDemo.mp4" frameborder="0" allowfullscreen="true"></iframe>
</figure>

# Features
- Move linearly in any 2D direction you specify.
- Dash to avoid bullets or deal extra damage.
- Shoot lightning chains to electrocute multiple enemies.
- Experience bullet-hell mechanics where you dodge multiple bullet types.

**Controls:**
- A: Move
- E: Dash
- S: Shoot lightning

Note: *Use the mouse cursor to choose your movement direction*

# Running instructions (for Godot users only)
I haven't exported the game yet so you can only play the debug version if you have godot installed. You will need to set tutorial.tscn as the main scene if it isn't so, and follow those steps to fix the blurry pixel art:

1) After opening the project, click on **Project** in the top-left corner of the screen, then select **Project Settings**.
2) Under **Rendering**, choose **Textures**.
3) Change the **Default Texture Filter** from **Linear** to **Nearest**
4) Exit the project settings and press **F5** to run the game.
5) Enjoy!

# Future Plans
1) **Art**: It will evolve as the game expands and more progress is made. All textures are placeholders for now. I am also planning to learn how to use shaders and VFX to make a prettier game.
2) **Fighting**: More bullet patterns and enemies will be added, and enemy attacks won't be limited to bullets.
3) **Abilities and Mechanics**: Lots of those will be added to give the game more variety and uniqueness, help navigate through traps and difficult areas, and limit progression. 
4) **World design**: This will come after the 3 other points are done. For now, I am simply working on the basic systems and modules that will shape the entire game.
