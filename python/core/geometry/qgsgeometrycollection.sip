class QgsGeometryCollection: public QgsAbstractGeometry
{
%TypeHeaderCode
#include <qgsgeometrycollection.h>
%End

  public:
    QgsGeometryCollection();
    QgsGeometryCollection( const QgsGeometryCollection& c );
    //QgsGeometryCollection& operator=( const QgsGeometryCollection& c );
    virtual ~QgsGeometryCollection();

    virtual QgsGeometryCollection* clone() const /Factory/;

    /** Returns the number of geometries within the collection.
     */
    int numGeometries() const;

    /** Returns a const reference to a geometry from within the collection.
     * @param n index of geometry to return
     */
    //const QgsAbstractGeometry* geometryN( int n ) const;

    /** Returns a geometry from within the collection.
     * @param n index of geometry to return
     */
    QgsAbstractGeometry* geometryN( int n );

    //methods inherited from QgsAbstractGeometry
    bool isEmpty() const;
    virtual int dimension() const;
    virtual QString geometryType() const;
    virtual void clear();
    virtual QgsAbstractGeometry* boundary() const /Factory/;

    /** Adds a geometry and takes ownership. Returns true in case of success.*/
    virtual bool addGeometry( QgsAbstractGeometry* g /Transfer/ );

    /** Inserts a geometry before a specified index and takes ownership. Returns true in case of success.
     * @param g geometry to insert. Ownership is transferred to the collection.
     * @param index position to insert geometry before
     */
    virtual bool insertGeometry( QgsAbstractGeometry* g /Transfer/, int index );

    /** Removes a geometry from the collection.
     * @param nr index of geometry to remove
     * @returns true if removal was successful.
     */
    virtual bool removeGeometry( int nr );

    void transform( const QgsCoordinateTransform& ct, QgsCoordinateTransform::TransformDirection d = QgsCoordinateTransform::ForwardTransform,
                    bool transformZ = false );
    void transform( const QTransform& t );

    //virtual void clip( const QgsRectangle& rect );

    virtual void draw( QPainter& p ) const;

    bool fromWkb( QgsConstWkbPtr& wkb );
    virtual bool fromWkt( const QString& wkt );
    QByteArray asWkb() const;
    QString asWkt( int precision = 17 ) const;
    QDomElement asGML2( QDomDocument& doc, int precision = 17, const QString& ns = "gml" ) const;
    QDomElement asGML3( QDomDocument& doc, int precision = 17, const QString& ns = "gml" ) const;
    QString asJSON( int precision = 17 ) const;

    virtual QgsRectangle boundingBox() const;

    virtual QList< QList< QList< QgsPointV2 > > > coordinateSequence() const;
    virtual int nCoordinates() const;
    virtual double closestSegment( const QgsPointV2& pt, QgsPointV2& segmentPt,  QgsVertexId& vertexAfter, bool* leftOf, double epsilon ) const;
    bool nextVertex( QgsVertexId& id, QgsPointV2& vertex ) const;

    //low-level editing
    virtual bool insertVertex( QgsVertexId position, const QgsPointV2& vertex );
    virtual bool moveVertex( QgsVertexId position, const QgsPointV2& newPos );
    virtual bool deleteVertex( QgsVertexId position );

    virtual double length() const;
    virtual double area() const;
    virtual double perimeter() const;

    bool hasCurvedSegments() const;

    /** Returns a geometry without curves. Caller takes ownership
    * @param tolerance segmentation tolerance
    * @param toleranceType maximum segmentation angle or maximum difference between approximation and curve*/
    QgsAbstractGeometry* segmentize( double tolerance = M_PI_2 / 90, SegmentationToleranceType toleranceType = MaximumAngle ) const /Factory/;

    /** Returns approximate rotation angle for a vertex. Usually average angle between adjacent segments.
     * @param vertex the vertex id
     * @return rotation in radians, clockwise from north
     */
    double vertexAngle( QgsVertexId vertex ) const;

    virtual int vertexCount( int part = 0, int ring = 0 ) const;
    virtual int ringCount( int part = 0 ) const;
    virtual int partCount() const;
    virtual QgsPointV2 vertexAt( QgsVertexId id ) const;

    virtual bool addZValue( double zValue = 0 );
    virtual bool addMValue( double mValue = 0 );
    virtual bool dropZValue();
    virtual bool dropMValue();

  protected:

    /** Returns whether child type names are omitted from Wkt representations of the collection
     * @note added in QGIS 2.12
     */
    virtual bool wktOmitChildType() const;

    /** Reads a collection from a WKT string.
     */
    bool fromCollectionWkt( const QString &wkt, const QList<QgsAbstractGeometry*>& subtypes, const QString& defaultChildWkbType = QString() );

    virtual QgsRectangle calculateBoundingBox() const;
    virtual void clearCache() const;

};
