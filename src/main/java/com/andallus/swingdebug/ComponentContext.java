package com.andallus.swingdebug;

public class ComponentContext {

    public String componentType = "";
    public String instantiationLocationType = "";
    public String assignmentName = "";
    public String assignmentLocationType = "";

    public ComponentContext(String componentType, String instantiationLocationType, String assignmentName, String assignmentLocationType) {
        this.componentType = componentType;
        this.instantiationLocationType = instantiationLocationType;
        this.assignmentName = assignmentName;
        this.assignmentLocationType = assignmentLocationType;
    }

    public String toString(){
        return "[ComponentType: "+componentType+", instantiationLocationType: "+instantiationLocationType+", assignmentName: "+assignmentName+", assignmentLocationType: "+assignmentLocationType+"]";
    }

}
