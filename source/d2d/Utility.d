module d2d.Utility;

import std.conv;
import std.math;
import d2d.sdl2;

/**
 * A color struct
 * As of right now, only works with additive RGBA, but may work with other formats later
 * Additive RGBA is where the color is stored as an addition of red, green, and blue
 * Alpha is the transparency of the color
 */
struct Color {
    ubyte r; ///Red value for the color
    ubyte g; ///Green value for the color
    ubyte b; ///Blue value for the color
    ubyte a = 255; ///Alpha value or transparency for the color
    private SDL_Color sdlColor;

    /**
     * Gets the color as an SDL_Color
     */
    @property SDL_Color* handle() {
        sdlColor = SDL_Color(r, g, b, a);
        return &sdlColor;
    }
}

/**
 * A point is a location in 2d space
 * Location is accessed by x and y coordinates
 */
class Point(T) if (__traits(isScalar, T)) {

    private SDL_Point sdlPoint;
    T x; ///X value of the point
    T y; ///Y value of the point

    /**
     * Gets the point as an SDL_Point
     */
    @property SDL_Point* handle() {
        sdlPoint = SDL_Point(this.x.to!int, this.y.to!int);
        return &sdlPoint;
    }

    /**
     * Returns the angle of the point relative to (0, 0)
     * Returns angles in radians and does angles where right is 0 and up is pi / 2
     */
    @property double angle() {
        return atan2(0.0 + this.y, 0.0 + this.x);
    }

    /**
     * Returns the distance from this point to (0, 0)
     */
    @property double magnitude(){
        return sqrt(0.0 + this.x * this.x + this.y * this.y);
    }

    /**
     * A point constructor; takes in an x value and a y value
     */
    this(T x, T y) {
        this.x = x;
        this.y = y;
    }

    /**
     * Modifies the point's x and y values by the x and y components of 
     * vector
     */
    void shift(Point!T vector){
        this.x += vector.x;
        this.y += vector.y;
    }

    /**
     * Sets the distance of the point to (0, 0) to the given amount
     * Retains the direction the point was facing
     */
    void setMagnitude(double magnitude){
        double tempAngle = this.angle;
        this.x = cast(T)(this.magnitude * cos(tempAngle));
        this.y = cast(T)(this.magnitude * sin(tempAngle));
    }

    /**
     * Scales the distance of the point from (0, 0) by the given multiplier.
     */
    void scale(double multiplier){
        this.x = cast(T)(this.x * multiplier);
        this.y = cast(T)(this.y * multiplier);
    }

    /**
     * Takes an angle, in radians, and rotates the point about (0, 0)
     */
    void setAngle(double angle){
        double tempMagnitude = this.magnitude;
        this.x = cast(T)(tempMagnitude * cos(this.angle));
        this.y = cast(T)(tempMagnitude * sin(this.angle));
    }

    /**
     * Rotates the point the given number of radians counter clockwise about (0, 0)
     */
    void rotate(double radians){
        this.setAngle(this.angle + radians);
    }

}

/**
 * A rectangle is a box in 2d space
 * This struct only does Axis Aligned Bounding Boxes (AABB) which don't have rotation
 */
class Rectangle(T) if (__traits(isScalar, T)) {

    private SDL_Rect sdlRectangle;
    Point!T topLeft; ///The top left point of the rectangle
    T w; ///The width of the rectangle
    T h; ///The height of the rectangle

    /**
     * Makes a rectangle given top left coordinates and a width and a height
     */
    this(T x, T y, T w, T h) {
        this.topLeft = new Point!T(x, y);
        this.w = w;
        this.h = h;
    }

    /**
     * Gets the rectangle as an SDL_Rect
     */
    @property SDL_Rect* handle() {
        sdlRectangle = SDL_Rect(topLeft.x.to!int, topLeft.y.to!int, w.to!int, h.to!int);
        return &sdlRectangle;
    }

}


alias iPoint = Point!int;
alias dPoint = Point!double;
alias fPoint = Point!float;
alias iRectangle = Rectangle!int;
alias dRectangle = Rectangle!double;
alias fRectangle = Rectangle!float;
