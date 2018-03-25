///scr_controller(page)
var page = argument0;

if(page == "intro"){

    //---Update intro text---
    //Loop through text file to create full narrative text strig (including carriage returns)
    var str = "";
    var file = file_text_open_read(working_directory + page + ".txt");
    while (!file_text_eof(file))str += file_text_readln(file) + "#";
    file_text_close(file);
    
    //Create narrative text
    var introText = instance_create(room_width / 2, room_height / 2, obj_introText);
    introText.str = str; 
       
}else{
    
    //Destroy existing instance to avoid overdraw
    if(instance_exists(obj_choiceButton)) instance_destroy(obj_choiceButton);
    if(instance_exists(obj_narrativeText)) instance_destroy(obj_narrativeText);
    if(instance_exists(obj_choiceText)) instance_destroy(obj_choiceText);
    if(instance_exists(obj_item)) instance_destroy(obj_item);
    
    //---Update narrative text---
    //Loop through text file to create full narrative text strig (including carriage returns)
    var str = "";
    var file = file_text_open_read(working_directory + page + ".txt");
    while (!file_text_eof(file))str += file_text_readln(file) + "#";
    file_text_close(file);
    
    //Create narrative text
    var narrativeText = instance_create(320, 64, obj_narrativeText);
    narrativeText.str = str;
    
    //---Update inventory display---
    var i;
    var countOwnedItems = 0;
    //Loop through the inventory, checking for found items
    for(i = 0; i < ds_grid_height(global.inventory); i++){
        var itemY;
        var itemX;
         
        //Set variables to position item images based on how many have been found so far   
        if(countOwnedItems < 4){itemY = obj_invContainer.y + 128 }else{itemY = obj_invContainer.y + 416};
        if(countOwnedItems < 4){
            itemX = obj_invContainer.x + 128 + (244 * countOwnedItems);
        }else{
            itemX = obj_invContainer.x + 128 + (244 * (countOwnedItems - 4));
        };
        
        //If the item is found and has not been destroyed, draw it to the inventory container
        if(ds_grid_get(global.inventory, 1, i) == 1 && ds_grid_get(global.inventory, 2, i) == 0){
            var item = instance_create(itemX, itemY, obj_item);
            item.image_index = ds_grid_get(global.inventory, 4, i);  
            countOwnedItems++;
        };
    };
    
    //---Update choice buttons---
    var k;
    for(k = 0; k < 5; k++){
        ini_open(working_directory + "choices.ini");
        
        //If current choice is not empty build its button
        if(ini_read_string(page + "Choices", k, "") != "NOTHING"){          
            //Set variables
            var textX = 736;
            var textY = 864 + (k * 128);
            
            //Create button and text
            var choiceButton = instance_create(textX, textY, obj_choiceButton);
            var choiceText = instance_create(textX, textY, obj_choiceText);
            
            //Set button and text values
            choiceButton.buttonNumber = k;
            choiceText.str = ini_read_string(page + "Choices", k, "");    
        };
        
        //Update button controls array with values for each button
        choiceButton.buttonNumber = k;
        choiceButton.target = ini_read_string(page + "Targets", k, "");
        choiceButton.inventoryGet = ini_read_string(page + "InventoryGet", k, "");
        choiceButton.inventoryNeed = ini_read_string(page + "InventoryNeed", k, "");
        choiceButton.inventoryMissingTarget = ini_read_string(page + "InventoryMissingTarget", k, "");
        choiceButton.inventoryDestroy = ini_read_string(page + "InventoryDestroy", k, "");
        
        ini_close();
    }
    
    //---Update image---
    ini_open(working_directory + "choices.ini");
    
    //Get image index
    var img = ini_read_real(page + "Image", "image_index", 0);
    
    //Update image index for sprite
    obj_image.image_index = img;
    
    ini_close();

};
